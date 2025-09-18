using AuthenticationServices.Common;
using System;
using System.Text;

namespace AuthenticationServices.Models.CompanyStructure
{
    public class DeleteCompanyTestDataModel : InputModelBase
    {
        public DeleteCompanyTestDataModel() : base(InputTypeGuidConstants.DeleteCompanyTestDataModelInputCommandTypeGuid)
        {
        }
        public Guid? CompanyId { get; set; }
        public Guid? UserId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CompanyId = " + CompanyId);
            stringBuilder.Append(", UserId = " + UserId);

            return stringBuilder.ToString();
        }
    }
}
