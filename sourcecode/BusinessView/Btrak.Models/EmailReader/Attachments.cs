using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.EmailReader
{
    public class Attachments
    {
        public string FileName { get; set; }
        public int Size { get; set; }
        public string ContentType { get; set; }
        public string FilePath { get; set; }
    }
}
