using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CompanyStructure
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
