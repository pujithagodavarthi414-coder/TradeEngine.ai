using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    [BsonIgnoreExtraElements]
    public class SearchFolderOutputModel
    {
        [BsonId]
        public Guid? Id { get; set; }
        public Guid? ParentFolderId { get; set; }
        public string Description { get; set; }
        public Guid? StoreId { get; set; }
        public Guid? FolderReferenceId { get; set; }
        public Guid? FolderReferenceTypeId { get; set; }
        public string FoldersAndFiles { get; set; }
        public string FolderName { get; set; }
        public Guid? FolderId { get; set; }
        public long? FolderSize { get; set; }
        public bool? IsArchived { get; set; }
        public string BreadCrumb { get; set; }
        public string Store { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public List<SearchFolderOutputModel> ChildFolders { get; set; }
    }
}
