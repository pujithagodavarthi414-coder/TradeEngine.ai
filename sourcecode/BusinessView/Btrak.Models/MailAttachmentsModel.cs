using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models
{
    public class MailAttachmentsModel
    {
        public Stream FileStream { get; set; }
        public bool IsPdf { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("FileStream" + FileStream);
            stringBuilder.Append("IsPdf" + IsPdf);
            return base.ToString();
        }
    }
}
