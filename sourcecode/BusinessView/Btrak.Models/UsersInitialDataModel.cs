using Btrak.Models.EntityType;
using Btrak.Models.MasterData;
using System.Collections.Generic;

namespace Btrak.Models
{
     public class UsersInitialDataModel
    {
        public List<CompanySettingsSearchOutputModel> CompanySettings { get; set; }
        public List<EntityRoleFeatureApiReturnModel> EntityFeatures { get; set; }
        public string TimeSheetButtonDetails { get; set; }
        public bool AddOrEditCustomAppIsRequired { get; set; }
    }
}
