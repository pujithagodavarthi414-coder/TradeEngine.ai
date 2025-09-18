using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class JobRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Job table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(JobDbEntity aJob)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aJob.Id);
					 vParams.Add("@DesignationId",aJob.DesignationId);
					 vParams.Add("@EmployeeId",aJob.EmployeeId);
					 vParams.Add("@EmploymentStatusId",aJob.EmploymentStatusId);
					 vParams.Add("@JobCategoryId",aJob.JobCategoryId);
					 vParams.Add("@JoinedDate",aJob.JoinedDate);
					 vParams.Add("@DepartmentId",aJob.DepartmentId);
					 vParams.Add("@LocationId",aJob.LocationId);
					 vParams.Add("@ContrcatStartDate",aJob.ContrcatStartDate);
					 vParams.Add("@ContrcatEndDate",aJob.ContrcatEndDate);
					 vParams.Add("@ContractDetails",aJob.ContractDetails);
					 vParams.Add("@CreatedDateTime",aJob.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aJob.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aJob.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aJob.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_JobInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Job table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(JobDbEntity aJob)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aJob.Id);
					 vParams.Add("@DesignationId",aJob.DesignationId);
					 vParams.Add("@EmployeeId",aJob.EmployeeId);
					 vParams.Add("@EmploymentStatusId",aJob.EmploymentStatusId);
					 vParams.Add("@JobCategoryId",aJob.JobCategoryId);
					 vParams.Add("@JoinedDate",aJob.JoinedDate);
					 vParams.Add("@DepartmentId",aJob.DepartmentId);
					 vParams.Add("@LocationId",aJob.LocationId);
					 vParams.Add("@ContrcatStartDate",aJob.ContrcatStartDate);
					 vParams.Add("@ContrcatEndDate",aJob.ContrcatEndDate);
					 vParams.Add("@ContractDetails",aJob.ContractDetails);
					 vParams.Add("@CreatedDateTime",aJob.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aJob.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aJob.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aJob.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_JobUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Job table.
		/// </summary>
		public JobDbEntity GetJob(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<JobDbEntity>("USP_JobSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Job table.
		/// </summary>
		 public IEnumerable<JobDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<JobDbEntity>("USP_JobSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the Job table by a foreign key.
		/// </summary>
		public List<JobDbEntity> SelectAllByDesignationId(Guid designationId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@DesignationId",designationId);
				 return vConn.Query<JobDbEntity>("USP_JobSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the Job table by a foreign key.
		/// </summary>
		public List<JobDbEntity> SelectAllByEmployeeId(Guid employeeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@EmployeeId",employeeId);
				 return vConn.Query<JobDbEntity>("USP_JobSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the Job table by a foreign key.
		/// </summary>
		public List<JobDbEntity> SelectAllByDepartmentId(Guid? departmentId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@DepartmentId",departmentId);
				 return vConn.Query<JobDbEntity>("USP_JobSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the Job table by a foreign key.
		/// </summary>
		public List<JobDbEntity> SelectAllByEmploymentStatusId(Guid employmentStatusId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@EmploymentStatusId",employmentStatusId);
				 return vConn.Query<JobDbEntity>("USP_JobSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the Job table by a foreign key.
		/// </summary>
		public List<JobDbEntity> SelectAllByJobCategoryId(Guid jobCategoryId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@JobCategoryId",jobCategoryId);
				 return vConn.Query<JobDbEntity>("USP_JobSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
