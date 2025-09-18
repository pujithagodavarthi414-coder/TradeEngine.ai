using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TestRail
{
    public class PdfGenerationOutputModel
    {
        public byte[] ByteStream { get; set; }

        public string BlobUrl { get; set; }

        public string FileName { get; set; }

        
    }
}
