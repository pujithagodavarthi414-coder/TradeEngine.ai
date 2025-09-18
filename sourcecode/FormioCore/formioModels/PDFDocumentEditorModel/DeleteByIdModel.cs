using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Newtonsoft.Json;

namespace Models.DeletePDFHTMLDesigner
{
    public class DeleteByIdRequest
    {
        [Required]
        public Guid? ID { get; set; }
    }

    public class DeleteByIdResponse
    {
        public bool IsSuccess { get; set; }
        public string Massage { get; set; }
    }

    public class DataServiceOutputModel
    {
        public object Data
        {
            get;
            set;
        }
    }

    public class RemoveByIdInputModel
    {
        public Guid _id { get; set; }
        public bool status { get; set; }
    }
}
