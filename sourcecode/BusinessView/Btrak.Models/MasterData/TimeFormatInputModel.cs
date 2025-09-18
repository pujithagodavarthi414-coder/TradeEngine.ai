using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class TimeFormatInputModel : InputModelBase
    {
        public TimeFormatInputModel() : base(InputTypeGuidConstants.TimeFormatInputCommandTypeGuid)
        {
        }
        public Guid? TimeFormatId { get; set; }
        public string TimeFormatName { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TimeFormatId = " + TimeFormatId);
            stringBuilder.Append(", TimeFormatName = " + TimeFormatName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}