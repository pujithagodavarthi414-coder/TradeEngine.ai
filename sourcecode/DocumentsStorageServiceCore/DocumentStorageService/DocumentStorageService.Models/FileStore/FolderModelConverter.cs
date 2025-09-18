using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    public class FolderModelConverter
    {
        public static FolderCollectionModel ConvertFolderUpsertInputModelToCollectionModel(UpsertFolderInputModel inputModel)
        {
            return new FolderCollectionModel
            {
               
                FolderName = inputModel.FolderName,
                Description = inputModel.Description,
                ParentFolderId = inputModel.ParentFolderId,
                StoreId = inputModel.StoreId,
                FolderReferenceId = inputModel.FolderReferenceId,
                FolderReferenceTypeId = inputModel.FolderReferenceTypeId,
                FolderSize = inputModel.Size ?? 0,
                IsArchived = false
               
            };
        }

        private static List<FolderCollectionModel> GetChildFolders(List<UpsertFolderInputModel> childFolders)
        {
            List<FolderCollectionModel> childFoldersCollection = new List<FolderCollectionModel>();
            foreach (var childFolder in childFolders)
            {
                var collection = new FolderCollectionModel();
                collection.FolderName = childFolder.FolderName;
                collection.Description = childFolder.Description;
                collection.ParentFolderId = childFolder.ParentFolderId;
                collection.StoreId = childFolder.StoreId;
                collection.FolderReferenceId = childFolder.FolderReferenceId;
                collection.FolderReferenceTypeId = childFolder.FolderReferenceTypeId;
                collection.FolderSize = childFolder.Size;
                childFoldersCollection.Add(collection);
            }

            return childFoldersCollection;
        }
    }
}
