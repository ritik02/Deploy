module QuestionMapperHelper
	question_hash = {
		title: "Title",
		overview: "Overview",
		committers: "Committers",
		services_impacted: "SERVICES IMPACTED",
		service_details_1: "Please provide URL for your wiki page for this specific change.",
		service_details_2: "Please provide datadog dashboard URL for your service",
		service_details_3: "Please provide newrelic dashboard URL for your service",
		service_rollback_1: "What’s your rollback strategy",
		service_rollback_2: "Do you switch rollback with feature flag or does it require complete deployment again?",
		service_component_database: "Service Component - Database",
		service_component_security: "Service Component - Security",
		service_component_monitoring: "Service Component - Monitoring",
		service_component_cache: "Service Component - Cache",
		service_component_api_changes: "Service Component - API Changes",
		service_component_api_changes_1: "Did you change API contract?",
		service_component_api_changes_2: "Is there versioned API for new version?",
		service_component_api_changes_3: "How are you ensuring backward compatibility",
		service_component_api_changes_4: "Is there is feature flag for this API to switch on and switch off?",
		service_component_api_changes_5: "What kind of API is this - does it make changes to database? Please provide API endpoint, protocol (http, grpc) and signature affected data contract.",
		service_component_analytics_impact_1: "Does your change impact BI, if yes, please explain how? And get a approval from Crystal.",
		service_component_consumer_app_impact_1: "Does your change impact mobile consumer app? If yes, how does it impact",
		service_component_consumer_app_impact_2: "What components does it impact on Consumer App",
		service_component_consumer_app_impact_3: "Are these features toggled for specific consumers or all of them?",
		service_component_consumer_app_impact_4: "How will you ensure staggered roll out",
		service_component_consumer_app_impact_5: "Is there mixpanel configuration or play store configuration",
		service_component_driver_app_impact: "Service Component - Driver App Impact",
		service_component_goresto_app_impact: "Service Component - GoResto App Impact",
		service_component_configuration_management_impact: "Service Component - Configuration Management Impact",
    service_component_system_configurations_1: "Did you check limits",
    service_component_system_configurations_2: "Did you check proxy update",
    service_component_system_configurations_3: "Does it require rollover deployment",
    service_component_system_configurations_4: "Does your code deployment requires full chef run on box",
    service_component_system_configurations_5: "How many boxes does this service deploy affect, list each of them.",
    service_component_system_configurations_6: "Do you have read and write clusters, please explain order of deployment",
    service_component_system_configurations_7: "Does your service implements circuit breaker? If yes, what’s the configuration?",
    service_component_system_configurations_8: "What’s the connection timeout configuration?",
    service_component_system_configurations_9: "What errors you would return if there are timeouts or internal errors?",
    project_component_code_1: "List down commits with acceptance criteria, if it’s adhoc, mention adhoc, if it’s adhoc thenget sign off from tech lead and product manager, ask them to document this ad-hoc storyand put a proper sign off",
	  project_component_code_2: "What kind of tests you have written for which acceptance criteria",
	  project_component_code_3: "Does your code deals with concurrency?",
	  project_component_code_4: "Are you from reading or writing to files",
	  project_component_code_5: "Are you reading or writing to same fields?",
	  project_component_code_6: "How many domain entities are impacted?",
	  project_component_code_7: "Do you read from database? If yes, then explain why do you need to read from database?And why don’t you use cache, also, how many places you utilise cache.",
	  project_component_code_8: "How many synchronous calls your code makes? (Also list down in impacted services)"
	}
end