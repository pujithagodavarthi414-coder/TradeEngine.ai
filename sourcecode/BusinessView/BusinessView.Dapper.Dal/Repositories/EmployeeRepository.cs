using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Btrak.Models.Employee;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeRepository : BaseRepository
	 {
        
        /// <summary>
        /// Saves a record to the Employee table.
        /// returns True if value saved successfullyelse false
        /// Throw exception with message value 'EXISTS' if the data is duplicate
        /// </summary>
        public bool Insert(EmployeeDbEntity aEmployee)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployee.Id);
					 vParams.Add("@UserId",aEmployee.UserId);
					 vParams.Add("@EmployeeNumber",aEmployee.EmployeeNumber);
					 vParams.Add("@GenderId",aEmployee.GenderId);
					 vParams.Add("@MaritalStatusId",aEmployee.MaritalStatusId);
					 vParams.Add("@NationalityId",aEmployee.NationalityId);
					 vParams.Add("@DateofBirth",aEmployee.DateofBirth);
					 vParams.Add("@Smoker",aEmployee.Smoker);
					 vParams.Add("@MilitaryService",aEmployee.MilitaryService);
					 vParams.Add("@NickName",aEmployee.NickName);
					 vParams.Add("@CreatedDateTime",aEmployee.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployee.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployee.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployee.UpdatedByUserId);
					 vParams.Add("@IsTerminated",aEmployee.IsTerminated);
					 int iResult = vConn.Execute("USP_EmployeeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Employee table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmployeeDbEntity aEmployee)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployee.Id);
					 vParams.Add("@UserId",aEmployee.UserId);
					 vParams.Add("@EmployeeNumber",aEmployee.EmployeeNumber);
					 vParams.Add("@GenderId",aEmployee.GenderId);
					 vParams.Add("@MaritalStatusId",aEmployee.MaritalStatusId);
					 vParams.Add("@NationalityId",aEmployee.NationalityId);
					 vParams.Add("@DateofBirth",aEmployee.DateofBirth);
					 vParams.Add("@Smoker",aEmployee.Smoker);
					 vParams.Add("@MilitaryService",aEmployee.MilitaryService);
					 vParams.Add("@NickName",aEmployee.NickName);
					 vParams.Add("@CreatedDateTime",aEmployee.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployee.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployee.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployee.UpdatedByUserId);
					 vParams.Add("@IsTerminated",aEmployee.IsTerminated);
					 int iResult = vConn.Execute("USP_EmployeeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

       

        /// <summary>
        /// Selects the Single object of Employee table.
        /// </summary>
        public EmployeeDbEntity GetEmployee(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmployeeDbEntity>("USP_EmployeeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}     

        /// <summary>
        /// Selects all records from the Employee table.
        /// </summary>
        public IEnumerable<EmployeeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeDbEntity>("USP_EmployeeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

       
    }
}
