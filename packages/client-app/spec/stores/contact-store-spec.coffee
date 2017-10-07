_ = require 'underscore'
Rx = require 'rx-lite'
{NylasTestUtils} = require 'nylas-exports'
Contact = require('../../src/flux/models/contact').default
NylasAPI = require('../../src/flux/nylas-api').default
NylasAPIRequest = require('../../src/flux/nylas-api-request').default
ContactStore = require '../../src/flux/stores/contact-store'
ContactRankingStore = require '../../src/flux/stores/contact-ranking-store'
DatabaseStore = require('../../src/flux/stores/database-store').default
AccountStore = require('../../src/flux/stores/account-store').default

{mockObservable} = NylasTestUtils

xdescribe "ContactStore", ->
  beforeEach ->
    spyOn(NylasEnv, "isMainWindow").andReturn true

    @rankings = [
      ["evanA@nylas.com", 10]
      ["evanB@nylas.com", 1]
      ["evanC@nylas.com", 0.1]
    ]

    spyOn(NylasAPIRequest.prototype, "run").andCallFake (options) =>
      if options.path is "/contacts/rankings"
        return Promise.resolve(@rankings)
      else
        throw new Error("Invalid request path!")

    NylasEnv.testOrganizationUnit = "folder"
    ContactStore._contactCache = []
    ContactStore._fetchOffset = 0
    ContactStore._accountId = null
    ContactRankingStore.reset()

  afterEach ->
    NylasEnv.testOrganizationUnit = null

  describe "ranking contacts", ->
    beforeEach ->
      @accountId = TEST_ACCOUNT_ID
      @c1 = new Contact({name: "Evan A", email: "evanA@nylas.com", @accountId})
      @c2 = new Contact({name: "Evan B", email: "evanB@nylas.com", @accountId})
      @c3 = new Contact({name: "Evan C", email: "evanC@nylas.com", @accountId})
      @c4 = new Contact({name: "Ben", email: "ben@nylas.com"})
      @contacts = [@c3, @c1, @c2, @c4]

    it "queries for, and sorts, contacts present in the rankings", ->
      spyOn(ContactRankingStore, 'valuesForAllAccounts').andReturn
        "evana@nylas.com": 10
        "evanb@nylas.com": 1
        "evanc@nylas.com": 0.1

      spyOn(DatabaseStore, 'findAll').andCallFake =>
        return {background: => Promise.resolve([@c3, @c1, @c2, @c4])}

      waitsForPromise =>
        ContactStore._updateRankedContactCache().then =>
          expect(ContactStore._rankedContacts).toEqual [@c1, @c2, @c3, @c4]

  describe "when ContactRankings change", ->
    it "re-generates the ranked contact cache", ->
      spyOn(ContactStore, "_updateRankedContactCache")
      ContactRankingStore.trigger()
      expect(ContactStore._updateRankedContactCache).toHaveBeenCalled()

  describe "when searching for a contact", ->
    beforeEach ->
      @c1 = new Contact(name: "", email: "1test@nylas.com")
      @c2 = new Contact(name: "First", email: "2test@nylas.com")
      @c3 = new Contact(name: "First Last", email: "3test@nylas.com")
      @c4 = new Contact(name: "Fit", email: "fit@nylas.com")
      @c5 = new Contact(name: "Fins", email: "fins@nylas.com")
      @c6 = new Contact(name: "Fill", email: "fill@nylas.com")
      @c7 = new Contact(name: "Fin", email: "fin@nylas.com")
      ContactStore._rankedContacts = [@c1,@c2,@c3,@c4,@c5,@c6,@c7]

    it "can find by first name", ->
      waitsForPromise =>
        ContactStore.searchContacts("First").then (results) =>
          expect(results.length).toBe 2
          expect(results[0]).toBe @c2
          expect(results[1]).toBe @c3

    it "can find by last name", ->
      waitsForPromise =>
        ContactStore.searchContacts("Last").then (results) =>
          expect(results.length).toBe 1
          expect(results[0]).toBe @c3

    it "can find by email", ->
      waitsForPromise =>
        ContactStore.searchContacts("1test").then (results) =>
          expect(results.length).toBe 1
          expect(results[0]).toBe @c1

    it "is case insensitive", ->
      waitsForPromise =>
        ContactStore.searchContacts("FIrsT").then (results) =>
          expect(results.length).toBe 2
          expect(results[0]).toBe @c2
          expect(results[1]).toBe @c3

    it "only returns the number requested", ->
      waitsForPromise =>
        ContactStore.searchContacts("FIrsT", limit: 1).then (results) =>
          expect(results.length).toBe 1
          expect(results[0]).toBe @c2

    it "returns no more than 5 by default", ->
      waitsForPromise =>
        ContactStore.searchContacts("fi").then (results) =>
          expect(results.length).toBe 5

    it "can return more than 5 if requested", ->
      waitsForPromise =>
        ContactStore.searchContacts("fi", limit: 6).then (results) =>
          expect(results.length).toBe 6

  describe 'isValidContact', ->
    it "should call contact.isValid", ->
      contact = new Contact()
      spyOn(contact, 'isValid').andReturn(true)
      expect(ContactStore.isValidContact(contact)).toBe(true)

    it "should return false for non-Contact objects", ->
      expect(ContactStore.isValidContact({name: 'Ben', email: 'ben@nylas.com'})).toBe(false)

    it "returns false if we're not passed a contact", ->
      expect(ContactStore.isValidContact()).toBe false

  describe 'parseContactsInString', ->
    testCases =
      # Single contact test cases
      "evan@nylas.com": [new Contact(name: "evan@nylas.com", email: "evan@nylas.com")]
      "Evan Morikawa": []
      "'evan@nylas.com'": [new Contact(name: "evan@nylas.com", email: "evan@nylas.com")]
      "\"evan@nylas.com\"": [new Contact(name: "evan@nylas.com", email: "evan@nylas.com")]
      "'evan@nylas.com": [new Contact(name: "'evan@nylas.com", email: "'evan@nylas.com")]
      "Evan Morikawa <evan@nylas.com>": [new Contact(name: "Evan Morikawa", email: "evan@nylas.com")]
      "Evan Morikawa (evan@nylas.com)": [new Contact(name: "Evan Morikawa", email: "evan@nylas.com")]
      "spang (Christine Spang) <noreply+phabricator@nilas.com>": [new Contact(name: "spang (Christine Spang)", email: "noreply+phabricator@nilas.com")]
      "spang 'Christine Spang' <noreply+phabricator@nilas.com>": [new Contact(name: "spang 'Christine Spang'", email: "noreply+phabricator@nilas.com")]
      "spang \"Christine Spang\" <noreply+phabricator@nilas.com>": [new Contact(name: "spang \"Christine Spang\"", email: "noreply+phabricator@nilas.com")]
      "Evan (evan@nylas.com)": [new Contact(name: "Evan", email: "evan@nylas.com")]
      "\"Michael\" (mg@nylas.com)": [new Contact(name: "Michael", email: "mg@nylas.com")]
      "announce-uc.1440659566.kankcagcmaacemjlnoma-security=nylas.com@lists.openwall.com": [new Contact(name: "announce-uc.1440659566.kankcagcmaacemjlnoma-security=nylas.com@lists.openwall.com", email: "announce-uc.1440659566.kankcagcmaacemjlnoma-security=nylas.com@lists.openwall.com")]

      # Multiple contact test cases
      "Evan Morikawa <evan@nylas.com>, Ben <ben@nylas.com>": [
        new Contact(name: "Evan Morikawa", email: "evan@nylas.com")
        new Contact(name: "Ben", email: "ben@nylas.com")
      ]
      "Evan Morikawa <evan@nylas.com>; Ben <ben@nylas.com>": [
        new Contact(name: "Evan Morikawa", email: "evan@nylas.com")
        new Contact(name: "Ben", email: "ben@nylas.com")
      ]
      "mark@nylas.com\nGleb (gleb@nylas.com)\rEvan Morikawa <evan@nylas.com>, spang (Christine Spang) <noreply+phabricator@nilas.com>": [
        new Contact(name: "", email: "mark@nylas.com")
        new Contact(name: "Gleb", email: "gleb@nylas.com")
        new Contact(name: "Evan Morikawa", email: "evan@nylas.com")
        new Contact(name: "spang (Christine Spang)", email: "noreply+phabricator@nilas.com")
      ]

    _.forEach testCases, (value, key) ->
      it "works for #{key}", ->
        waitsForPromise ->
          ContactStore.parseContactsInString(key).then (contacts) ->
            contacts = contacts.map (c) -> c.toString()
            expectedContacts = value.map (c) -> c.toString()
            expect(contacts).toEqual expectedContacts
