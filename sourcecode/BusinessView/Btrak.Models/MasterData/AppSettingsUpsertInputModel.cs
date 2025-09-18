using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class AppSettingsUpsertInputModel : InputModelBase
    {
        public AppSettingsUpsertInputModel() : base(InputTypeGuidConstants.LicenceTypeInputCommandTypeGuid)
        {
        }

        public string AppSettingsName { get; set; }
        public string AppSettingsValue { get; set; }
        public Guid? AppSettingsId { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsSystemLevel { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("AppSettingsName = " + AppSettingsName);
            stringBuilder.Append("AppSettingsValue = " + AppSettingsValue);
            stringBuilder.Append("AppSettingsId = " + AppSettingsId);
            stringBuilder.Append("IsArchived = " + IsArchived);
            stringBuilder.Append("IsSystemLevel = " + IsSystemLevel);
            return stringBuilder.ToString();
        }
    }
}