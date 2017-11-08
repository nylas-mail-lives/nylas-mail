import Rx from 'rx-lite'
import React from 'react'
import NylasStore from 'nylas-store'
import {FeatureUsedUpModal} from 'nylas-component-kit'
import Actions from '../actions'
import IdentityStore from './identity-store'
import TaskQueueStatusStore from './task-queue-status-store'
import SendFeatureUsageEventTask from '../tasks/send-feature-usage-event-task'

class NoProAccess extends Error { }

/**
 * FeatureUsageStore is backed by the IdentityStore
 *
 * The billing site is responsible for returning with the Identity object
 * a usage hash that includes all supported features, their quotas for the
 * user, and the current usage of that user. We keep a cache locally
 *
 * The Identity object (aka Nylas ID or N1User) has a field called
 * `feature_usage`. The schema for `feature_usage` is computed dynamically
 * in `compute_feature_usage` here:
 * https://github.com/nylas/cloud-core/blob/master/redwood/models/n1.py#L175-207
 *
 * The schema of each feature is determined by the `FeatureUsage` model in
 * redwood here:
 * https://github.com/nylas/cloud-core/blob/master/redwood/models/feature_usage.py#L14-32
 *
 * The final schema looks like (Feb 7, 2017):
 *
 * NylasID = {
 *   ...
 *   "feature_usage": {
 *     "snooze": {
 *       "quota": 15,
 *       "period": "monthly",
 *       "used_in_period": 10,
 *       "feature_limit_name": "snooze-experiment-A",
 *     },
 *     "send-later": {
 *       "quota": 99999,
 *       "period": "unlimited",
 *       "used_in_period": 228,
 *       "feature_limit_name": "send-later-unlimited-A",
 *     },
 *     "reminders": {
 *       "quota": 10,
 *       "period": "daily",
 *       "used_in_period": 10,
 *       "feature_limit_name": null,
 *     },
 *   },
 *   ...
 * }
 *
 * Valid periods are:
 * 'hourly', 'daily', 'weekly', 'monthly', 'yearly', 'unlimited'
 */
class FeatureUsageStore extends NylasStore {
  constructor() {
    super()
    this._waitForModalClose = []
    this.NoProAccess = NoProAccess
  }

  activate() {
    this._usub = Actions.closeModal.listen(this._onModalClose)
  }

  deactivate() {
    this._usub()
  }

  async asyncUseFeature(feature, {lexicon = {}} = {}) {
      return this._markFeatureUsed(feature)
  }

  _onModalClose = async () => {
    this._waitForModalClose = []
  }

  _modalText(feature, lexicon = {}) {
    let headerText = `Yay!`;
    let rechargeText = `You’ll have 99 more because you are awesome`
    return {headerText, rechargeText}
  }

  _featureData(feature) {
    return true
  }

  _isUsable(feature) {
    return true
  }

  async _markFeatureUsed(featureName) {
    return 99
  }

  _featureUsage() {
    return Object.assign({}, IdentityStore.identity().feature_usage) || {}
  }
}

export default new FeatureUsageStore()
