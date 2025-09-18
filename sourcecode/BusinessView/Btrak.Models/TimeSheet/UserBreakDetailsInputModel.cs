using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TimeSheet
{
    public class UserBreakDetailsInputModel : InputModelBase
    {
        public UserBreakDetailsInputModel() : base(InputTypeGuidConstants.TimeSheetInputCommandTypeGuid)
        {
        }

        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? BreakId { get; set; }
        public Guid? UserId { get; set; }
        public DateTime Date { get; set; }

        public string TimeZoneOffset { get; set; }
        public string TimeZone { get; set; }
        public DateTimeOffset? DateFromOffset { get; set; }
        public DateTimeOffset? DateToOffset { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
        
            stringBuilder.Append(", BreakId = " + BreakId);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", Date = " + Date);
            return stringBuilder.ToString();
        }
    }
}
