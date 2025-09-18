using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class PartsOfDayUpsertInputModel : InputModelBase
    {
        public PartsOfDayUpsertInputModel() : base(InputTypeGuidConstants.PartsOfDayInputCommandTypeGuid)
        {
        }

        public Guid? PartsOfDayId { get; set; }
        public string PartsOfDayName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PartsOfDayId = " + PartsOfDayId);
            stringBuilder.Append(",PartsOfDayName = " + PartsOfDayName);
            return stringBuilder.ToString();
        }
    }
}
