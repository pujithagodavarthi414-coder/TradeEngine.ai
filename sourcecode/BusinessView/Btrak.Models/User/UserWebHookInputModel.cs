using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.User
{
    public class UserWebHookInputModel
    {
        public Guid? UserId { get; set; }
        public List<string> WebHooksList { get; set; }
        public string WebHookXml { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" WebHooksList = " + WebHooksList);
            stringBuilder.Append(", UserId  = " + UserId);
            return stringBuilder.ToString();
        }
    }
}
