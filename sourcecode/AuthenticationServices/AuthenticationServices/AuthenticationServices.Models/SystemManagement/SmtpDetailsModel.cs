namespace AuthenticationServices.Models.SystemManagement
{
    public class SmtpDetailsModel
    {
        public string SmtpServer { get; set; }
        public string SmtpServerPort { get; set; }
        public string SmtpMail { get; set; }
        public string SmtpPassword { get; set; }
        public string CompanyName { get; set; }
        public string FromAddress { get; set; }
        public string FromName { get; set; }
    }
}
