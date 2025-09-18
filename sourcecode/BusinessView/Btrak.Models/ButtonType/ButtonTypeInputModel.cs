using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.ButtonType
{
    public class ButtonTypeInputModel : SearchCriteriaInputModelBase
    {
        public ButtonTypeInputModel() : base(InputTypeGuidConstants.ButtonTypeInputCommandTypeGuid)
        {
        }
        public Guid? ButtonTypeId { get; set; }
        public string ButtonTypeName { get; set; }
        public string shortName { get; set; }
        public string DeviceId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" ButtonTypeId = " + ButtonTypeId);
            stringBuilder.Append(", ButtonTypeName = " + ButtonTypeName);
            stringBuilder.Append(", shortName = " + shortName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", DeviceId = " + DeviceId);
            return stringBuilder.ToString();
        }
    }
}
