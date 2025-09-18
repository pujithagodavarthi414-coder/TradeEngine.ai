using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CompanyStructure
{
    public class SendMailInputModel
    {
        public string Email { get; set; }
        public string Description { get; set; }
        public string PhoneNumber { get; set; }
        public string PersonName { get; set; }
        public string CompanyName { get; set; }
        public string CompanyLogo { get; set; }
        public string PdfURL { get; set; }
        public string Date { get; set; }


    }
}
