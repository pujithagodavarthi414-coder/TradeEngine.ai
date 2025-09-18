using AuthenticationServices.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Models.CompanyStructure
{
    public class ArchiveCompanyInputModel : InputModelBase
    {
        public ArchiveCompanyInputModel() : base(InputTypeGuidConstants.ArchiveCompanyInputCommandTypeGuid)
        {
        }

        public Guid? CompanyId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CompanyId = " + CompanyId);

            return stringBuilder.ToString();
        }
    }
}
