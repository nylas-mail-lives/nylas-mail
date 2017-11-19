import _ from 'underscore';
import {FeatureUsageStore, Actions, AccountStore, DatabaseStore, Thread} from 'nylas-exports';
import SnoozeUtils from './snooze-utils'
import momentTimezone from 'moment-timezone'
import {PLUGIN_ID, PLUGIN_NAME} from './snooze-constants';
import SnoozeActions from './snooze-actions';

class SnoozeStore {

  constructor(pluginId = PLUGIN_ID, pluginName = PLUGIN_NAME) {
    this.pluginId = pluginId
    this.pluginName = pluginName
    this.accountIds = _.pluck(AccountStore.accounts(), 'id')
    this.snoozeCategoriesPromise = SnoozeUtils.getSnoozeCategoriesByAccount(AccountStore.accounts())
  }

  activate() {
    this.unsubscribers = [
      AccountStore.listen(this.onAccountsChanged),
      SnoozeActions.snoozeThreads.listen(this.onSnoozeThreads),
    ]
    setInterval(this.onUnsnoozeThreads, 60000);  // TODO: Do this a better way.
  }

  recordSnoozeEvent(threads, snoozeDate, label) {
    try {
      const timeInSec = Math.round(((new Date(snoozeDate)).valueOf() - Date.now()) / 1000);
      Actions.recordUserEvent("Threads Snoozed", {
        timeInSec: timeInSec,
        timeInLog10Sec: Math.log10(timeInSec),
        label: label,
        numItems: threads.length,
      });
    } catch (e) {
      // Do nothing
    }
  }

  onAccountsChanged = () => {
    const nextIds = _.pluck(AccountStore.accounts(), 'id')
    const isSameAccountIds = (
      this.accountIds.length === nextIds.length &&
      this.accountIds.length === _.intersection(this.accountIds, nextIds).length
    )
    if (!isSameAccountIds) {
      this.accountIds = nextIds
      this.snoozeCategoriesPromise = SnoozeUtils.getSnoozeCategoriesByAccount(AccountStore.accounts())
    }
  };

  onSnoozeThreads = (threads, snoozeDate, label) => {
    const lexicon = {
      displayName: "Snooze",
      usedUpHeader: "All Snoozes used",
      iconUrl: "nylas://thread-snooze/assets/ic-snooze-modal@2x.png",
    }

    SnoozeUtils.moveThreadsToSnooze(threads, this.snoozeCategoriesPromise, snoozeDate)
    .then((updatedThreads) => {
      _.each(updatedThreads, (update) => {
        Actions.setMetadata(update, this.pluginId, { expiration: snoozeDate })
      });
    })
    .catch((error) => {
      SnoozeUtils.moveThreadsFromSnooze(threads, this.snoozeCategoriesPromise)
      Actions.closePopover();
      NylasEnv.reportError(error);
      NylasEnv.showErrorDialog(`Sorry, we were unable to save your snooze settings. ${error.message}`);
      return
    });
  };

  onUnsnooze = () => {
    var snoozeCategories = []
    SnoozeUtils.getSnoozeCategoriesByAccount().then(categories => {
      _.each(categories, function(category) {
        snoozeCategories.push(category.serverId);
      });
      return snoozeCategories;
    }).then(snoozeCategories => {
      DatabaseStore.findAll(Thread).where([
        Thread.attributes.pluginMetadata.contains('thread-snooze'),
        Thread.attributes.categories.contains(snoozeCategories)
      ]).then(threads => {
        if(threads.length < 1) {
          return; // Nothing to do
        }
        
        for(const thread of threads) {
          var metadatum = thread.metadataObjectForPluginId('thread-snooze');
          if(_momentTimezone().isSameOrAfter(metadatum.value.expiration)) {
            SnoozeUtils.moveThreadsFromSnooze([thread], this.snoozeCategoriesPromise);
            Actions.setMetadata(thread, this.pluginId, { expiration: null });
          }
        }
      });
    });
  }
  
  deactivate() {
    this.unsubscribers.forEach(unsub => unsub())
  }
}

export default SnoozeStore;
