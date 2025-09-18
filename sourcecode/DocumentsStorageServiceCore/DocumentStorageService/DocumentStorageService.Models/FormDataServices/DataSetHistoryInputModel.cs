using System;

namespace DocumentStorageService.Models.FormDataServices
{
    public class DataSetHistoryInputModel
    {
        public Guid? Id { get; set; }
        public Guid? DataSetId { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public string Field { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string CreatedByUserName { get; set; }
        public string ProfileImage { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public string Description { get; set; }
        public string DataSourceName { get; set; }
        public Guid? DataSourceId { get; set; }
    }

    public class DataServiceOutputModel
    {
        public object Data
        {
            get;
            set;
        }
    }
}
