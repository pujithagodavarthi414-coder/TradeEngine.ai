using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Integration
{
    public class IntegrationDetailsModel
    {
        public string IntegrationUrl { get; set; }
        public string IntegrationType { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
    }
}
