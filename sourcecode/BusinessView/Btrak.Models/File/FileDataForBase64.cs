using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.File
{
    public class FileDataForBase64
    {
        public string ContentType { get; set; }
        public string Base64 { get; set; }
        public string FileName { get; set; }
    }
}
