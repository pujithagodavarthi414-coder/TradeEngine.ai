using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Models.Modules
{
   public class CompanyModuleUpsertModel
    {
        public Guid? CompanyId { get; set; }
        public Guid? ModuleId { get; set; }
        public string ModuleIdsList { get; set; }
        
    }
}
