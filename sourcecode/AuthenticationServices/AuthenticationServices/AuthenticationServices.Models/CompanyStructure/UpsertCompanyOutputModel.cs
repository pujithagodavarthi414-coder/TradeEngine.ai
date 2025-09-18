using System;
using System.Text;

namespace AuthenticationServices.Models.CompanyStructure
{
    public class UpsertCompanyOutputModel
    {
        public Guid? CompanyId { get; set; }
        public Guid? UserId { get; set; }
        public Guid? RoleId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", CompanyId   = " + CompanyId);
            stringBuilder.Append(", UserId   = " + UserId);
            stringBuilder.Append(", RoleId   = " + RoleId);
            return stringBuilder.ToString();
        }
    }
}
