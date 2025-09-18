using AuthenticationServices.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Models.Modules
{
   public  class CompanyModuleSearchInputModel : SearchCriteriaInputModelBase
    {
        public CompanyModuleSearchInputModel() : base(InputTypeGuidConstants.GetCompanyModules)
        {

        }
    }
}
