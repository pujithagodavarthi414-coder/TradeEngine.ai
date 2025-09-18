using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.File
{
    public class UpsertFileInputModel
    {
        public Guid? FolderId { get; set; }
        public Guid? StoreId { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public string ReferenceTypeName { get; set; }
        public Guid? FileTypeReferenceId { get; set; }
        public bool? IsFromFeedback { get; set; }
        public int FileType { get; set; }
        public string FilesXML { get; set; }
        public List<FileModel> FilesList { get; set; }
        public bool? IsToBeReviewed { get; set; }
        public string FolderName { get; set; }
        public List<string> ParentFolderNames { get; set; }
        public bool? IsArchived { get; set; }
        public List<UpsertFileInputModel> Versions { get; set; }
        public int? VersionNumber { get; set; }
        public Guid? DocumentId { get; set; }
        public string DocumentUrl { get; set; }
    }
}
