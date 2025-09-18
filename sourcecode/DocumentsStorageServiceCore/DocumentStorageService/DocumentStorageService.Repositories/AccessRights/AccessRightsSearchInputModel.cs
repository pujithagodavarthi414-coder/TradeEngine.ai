using System;
using System.Collections.Generic;
using System.Text;
using DocumentStorageService.Models.FileStore;

namespace DocumentStorageService.Repositories.AccessRights
{
   public  class AccessRightsSearchInputModel : SearchCriteriaInputModelBase
    {
        public AccessRightsSearchInputModel()
        {

        }
        public Guid? Id { get; set; }
        public Guid? DocumentId { get; set; }
        public bool? IsArchived { get; set; }
    }
}
