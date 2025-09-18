using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Crm.Sms
{
    public class MobileAuthenticationInputModel
    {
        public string MobileNumber { get; set; }
        public string CountryCode { get; set; }
        public string otp { get; set; }
    }
}
