using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class Appsettings : InputModelBase
    {
        public Appsettings() : base(InputTypeGuidConstants.AppSettingsSearchInputCommandTypeGuid)
        {
        }

        public Guid? AppsettingsId { get; set; }
        public string SearchText { get; set; }
        public string AppSettingsName { get; set; }
        public bool? IsArchived { get; set; }
        
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("AppsettingsId = " + AppsettingsId);
            stringBuilder.Append(", SearchText   = " + SearchText);
            stringBuilder.Append(", AppSettingsName   = " + AppSettingsName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }

}
