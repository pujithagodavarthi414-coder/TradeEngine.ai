using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.CompanyStructure
{
    public class ModuleDetailsModel : SearchCriteriaInputModelBase
    {
        public ModuleDetailsModel() : base(InputTypeGuidConstants.SearchIndustryModule)
        {
        }
        public Guid? ModuleId { get; set; }
        public List<Guid> ModuleIds { get; set; }
        public string ModuleIdXml { get; set; }
        public string ModuleIdsList { get; set; }
        public Guid? CompanyModuleId { get; set; }
        public string ModuleName { get; set; }
        public bool? IsEnabled { get; set; }
        public bool? IsFromSupportUser { get; set; }
        public bool? IsForCustomApp { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", IndustryModuleId  = " + ModuleId);
            return stringBuilder.ToString();
        }
    }
}
