using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TimeSheet
{
    public class UpsertUserPunchCardInputModel : InputModelBase
    {
        public UpsertUserPunchCardInputModel() : base(InputTypeGuidConstants.UpsertUserPunchCardInputCommandTypeGuid)
        {
        }
        public Guid? ButtonTypeId { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public bool? IsMobilePunchCard { get; set; }
        public bool? IsFeed { get; set; }
        public string UserReason { get; set; }
        public DateTimeOffset? ButtonClickedDate { get; set; }
        public string TimeZoneName { get; set; }
        public string DeviceId { get; set; }
        public bool AutoTimeSheet { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", ButtonTypeId = " + ButtonTypeId);
            stringBuilder.Append(", Latitude = " + Latitude);
            stringBuilder.Append(", Longitude = " + Longitude);
            stringBuilder.Append(", IsMobilePunchCard = " + IsMobilePunchCard);
            stringBuilder.Append(", IsFeed = " + IsFeed);
            return stringBuilder.ToString();
        }
    }
}
