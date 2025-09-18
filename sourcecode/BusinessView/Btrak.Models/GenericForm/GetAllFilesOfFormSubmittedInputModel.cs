using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
    public class GetAllFilesOfFormSubmittedInputModel
    {
        public Guid GenericFormSubmittedId { get; set; }

    }
    public class GetAllFilesOfFormSubmittedOutputModel
    {
        public Guid? FileId { get; set; }
        public string FileName { get; set; }
        public string FilePath { get; set; }
        public string FileExtension { get; set; }
        public string SfdtTemplate { get; set; }
    }
    public class GenerateCompleteTemplatesOutputModel
    {
        public Guid? _id { get; set; }
        public string InvoiceDowloadId { get; set; }
        public Guid GenericFormSubmittedId { get; set; }
        public string SfdtTemplatesToDownload { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
    }
}
