using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Dapper.Dal.Models
{
    public class UsersByCompanyIdModel
    {
        public Guid? UserId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId   = " + UserId);
            return stringBuilder.ToString();
        }
    }
}
