using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    public class BtrakPostedFile
    {
        public string FileName { get; set; }
        public string ContentType { get; set; }
        public Stream InputStream { get; set; }
    }
}
