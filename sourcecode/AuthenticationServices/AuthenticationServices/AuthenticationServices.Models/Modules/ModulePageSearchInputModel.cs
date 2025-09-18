using AuthenticationServices.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Models.Modules
{
    public class ModulePageSearchInputModel : SearchCriteriaInputModelBase
    {
        public ModulePageSearchInputModel() : base(InputTypeGuidConstants.GetCompanyModules)
        {

        }
        public Guid? ModuleId { get; set; }
        public Guid? ModulePageId { get; set; }
        public Guid? ModuleLayoutId { get; set; }
    }
}
