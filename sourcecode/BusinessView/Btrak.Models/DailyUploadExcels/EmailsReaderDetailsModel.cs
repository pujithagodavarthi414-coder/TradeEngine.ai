using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.DailyUploadExcels
{
    public class EmailsReaderDetailsModel
    {
        public string Email { get; set; }
        public string Password { get; set; }
        public string Subject { get; set; }
        public Guid CompanyId { get; set; }
        public string CompanyName { get; set; }
        public string UserMail { get; set; }
        public Guid UserId { get; set; }
        public string AuthToken { get; set; }
    }
}
