using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.File
{
    public class UploadFileToBlobInputModel
    {
        public string LocalFilePath { get; set; }
        public string FileName { get; set; }
        public int ModuleTypeId { get; set; }
        public string ContentType { get; set; }
        public Guid? ParentDocumentId { get; set; }
        public byte[] Bytes { get; set; }
    }
}
