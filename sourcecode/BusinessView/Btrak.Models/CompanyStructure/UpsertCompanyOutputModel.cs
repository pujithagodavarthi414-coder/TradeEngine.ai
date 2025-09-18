using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.CompanyStructure
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
