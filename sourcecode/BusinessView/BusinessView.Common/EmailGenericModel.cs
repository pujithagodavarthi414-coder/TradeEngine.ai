using System.Collections.Generic;
using System.IO;

namespace BTrak.Common
{
    public class EmailGenericModel
    {
        public string SmtpServer { get; set; }
        public string SmtpServerPort { get; set; }
        public string SmtpMail { get; set; }
        public string SmtpPassword { get; set; }
        public string[] ToAddresses { get; set; }
        public string HtmlContent { get; set; }
        public string Subject { get; set; }
        public string[] CCMails { get; set; }
        public string[] BCCMails { get; set; }
        public List<Stream> MailAttachments { get; set; }
        public List<StreamWithType> MailAttachmentsWithFileType { get; set; }
        public bool? IsPdf { get; set; }
        public string FromMailAddress { get; set; }
        public string FromName { get; set; }
        public string FooterAddress { get; set; }
    }

    public class StreamWithType
    {
        public Stream FileStream { get; set; }
        public string FileType { get; set; }
        public string FileName { get; set; }
        public bool? IsPdf { get; set; }
        public bool? IsExcel { get; set; }
        public bool? IsJpg { get; set; }
        public bool? IsJpeg { get; set; }
        public bool? IsPng { get; set; }
        public bool? IsDocx { get; set; }
        public bool? IsTxt { get; set; }
    }
}
