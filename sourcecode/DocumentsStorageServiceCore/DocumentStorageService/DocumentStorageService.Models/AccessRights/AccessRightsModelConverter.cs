using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.AccessRights
{
   public  class AccessRightsModelConverter
    {
        public static AccessRightsCollectionModel ConvertAccessRightsModelToCollectionModel(DocumentRightAccessModel inputModel)
        {
            return new AccessRightsCollectionModel
            {
                Id = inputModel.Id ?? Guid.NewGuid(),
                UserId = inputModel.UserId,
                DocumentId = inputModel.DocumentId,
                IsEditAccess = inputModel.IsEditAccess,
                IsViewAccess = inputModel.IsViewAccess,
                IsCreateAccess = inputModel.IsCreateAccess,
                RoleId = inputModel.RoleId,
                IsArchived = false

            };
        }
    }
}
