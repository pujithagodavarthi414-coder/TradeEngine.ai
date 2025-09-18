using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Crm.Sms
{
    public class SendSmsInputModel
    {
        public string MobileNumber { get; set; }
        public Guid TemplateId { get; set; }
        public string TemplateName { get; set; }
        public string OtpNumber { get; set; }
        public bool IsOtp { get; set; }
        public bool IsResend { get; set; }
        public string TextMessage { get; set; }
        public Guid? ReceiverId { get; set; }
        public Guid? UserId { get; set; }
        public Guid? CompanyId { get; set; }
    }
}
