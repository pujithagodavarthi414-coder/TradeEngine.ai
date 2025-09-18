using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.EmailReader
{
    public class EmailReaderModel
    {
        public string Subject { get; set; }
        public string FromAddress { get; set; }
        public int MessageNumber { get; set; }
        public DateTime? MessageSentDate { get; set; }
        public string Message { get; set; }
        public List<Attachments> FileAttachments { get; set; }
    }
}
