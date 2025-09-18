using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class AssetNotificationModel: NotificationBase
    {
        public Guid NotificationAssignedByUserGuid { get; }
        public Guid NotificationAssignedToUserGuid { get; }
        public Guid? AssetId { get; }
        public string AssetsNames { get; }
        public string AssetNumbers { get; }
        public AssetNotificationModel(string summary,
                                             Guid notificationAssignedByUserGuid,
                                             Guid notificationAssignedToUserGuid,
                                             Guid? assetId,
                                             string assetNames,
                                             string assetNumbers) : base(NotificationTypeConstants.NewAssetAssigned, summary
            )
        {
            NotificationAssignedByUserGuid = notificationAssignedByUserGuid;
            NotificationAssignedToUserGuid = notificationAssignedToUserGuid;
            AssetId = assetId;
            AssetsNames = assetNames;
            AssetNumbers = assetNumbers;

            Channels.Add(string.Format(NotificationChannelNamesConstants.AssetAssignment, notificationAssignedToUserGuid));
        }

    }
}
