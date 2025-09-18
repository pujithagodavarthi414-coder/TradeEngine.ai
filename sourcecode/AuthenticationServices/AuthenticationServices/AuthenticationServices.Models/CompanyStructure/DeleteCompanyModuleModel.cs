using AuthenticationServices.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Models.CompanyStructure
{
    public class DeleteCompanyModuleModel : InputModelBase
    {
        public DeleteCompanyModuleModel() : base(InputTypeGuidConstants.DeleteCompanyModuleModelInputCommandTypeGuid)
        {
        }
        public Guid? CompanyModuleId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CompanyModuleId = " + CompanyModuleId);

            return stringBuilder.ToString();
        }
    }
}
