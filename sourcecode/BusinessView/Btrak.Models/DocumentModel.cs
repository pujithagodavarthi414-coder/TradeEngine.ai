using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models
{
    public class DocumentModel
    {
        public Guid? DocumentId { get; set; }
        public string DocumentName { get; set; }
        public int DocumentOrder { get; set; }
        public bool? IsDocumentMandatory { get; set; }
        public string FileExtension { get; set; }
        public string FilePath { get; set; }
        public string Name { get; set; }
    }
}
