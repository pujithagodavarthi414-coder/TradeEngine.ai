using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class DateFormatInputModel : InputModelBase
    {
        public DateFormatInputModel() : base(InputTypeGuidConstants.DateFormatInputCommandTypeGuid)
        {
        }
        public Guid? DateFormatId { get; set; }
        public string DateFormatName { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("DateFormatId = " + DateFormatId);
            stringBuilder.Append(", DateFormatText = " + DateFormatName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}