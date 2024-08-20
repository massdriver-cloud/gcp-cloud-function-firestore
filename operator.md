## Google Cloud Function for Firestore

Google Cloud Functions is a lightweight, serverless compute solution for developers to create single-purpose, stand-alone functions that respond to cloud events without creating servers or managing infrastructure. Cloud Functions can be triggered by Firestore events, such as when documents are created, updated, or deleted.

### Design Decisions

1. **Event Trigger Configuration**: The Cloud Function is configured to trigger on Firestore events (create, update, delete, or a combination), allowing for real-time response to database changes.
2. **Service Dependencies**: The module ensures that necessary APIs (like Cloud Build and Cloud Functions) are enabled before deploying the Cloud Function.
3. **Temporary Storage for Deployment**: A Google Cloud Storage bucket is created to store a zip file, which acts as a placeholder for deployment. The actual application code is expected to be managed and deployed through other means.
4. **Runtime Selection**: The runtime environment for the Cloud Function, such as Node.js, Python, etc., is determined by the input variables, ensuring flexibility depending on the use case.
5. **Resource Labels and Metadata**: Resource labeling and metadata tagging are used for better management and identification of deployed resources.

### Runbook

#### Cloud Function Deployment Failures

If the Cloud Function fails to deploy, it might be due to various reasons like incorrect configurations or missing dependencies. You can use the following commands to gather more information:

```sh
# Check for errors in Cloud Build logs
gcloud builds list --filter="status=FAILURE"

# Get detailed logs for a specific build
gcloud builds log [BUILD_ID]

# Check Cloud Function log for debugging
gcloud functions logs read [FUNCTION_NAME] --region=[REGION]
```

#### Firestore Trigger Not Invoking Function

If your Cloud Function is not responding to Firestore events, there might be an issue with the trigger configuration:

```sh
# Verify the event trigger settings
gcloud functions describe [FUNCTION_NAME] --region=[REGION] --format="json(eventTrigger)"

# Ensure Firestore has the expected changes
gcloud firestore documents list --project=[PROJECT_ID] --collection=[COLLECTION_NAME]

# Look for Firestore-trigger logs
gcloud logging read "resource.type=cloud_function AND resource.labels.function_name=[FUNCTION_NAME]" --region=[REGION]
```

#### Permissions Issues

If your Cloud Function is having permissions issues, such as not being able to access Firestore, check the IAM policies:

```sh
# Check IAM policy for the Cloud Function service account
gcloud projects get-iam-policy [PROJECT_ID] --flatten="bindings[].members" --format="table(bindings.role)"

# Ensure the necessary roles are assigned
gcloud projects add-iam-policy-binding [PROJECT_ID] --member="serviceAccount:[SERVICE_ACCOUNT_EMAIL]" --role="roles/datastore.user"
```

#### Debugging Firestore Data Issues

If you suspect issues with the actual Firestore data that might be triggering the function incorrectly:

```sh
# List documents in a specific collection
gcloud firestore documents list --project=[PROJECT_ID] --collection=[COLLECTION_NAME]

# Get a specific document to check its structure and data
gcloud firestore documents describe projects/[PROJECT_ID]/databases/(default)/documents/[COLLECTION_NAME]/[DOCUMENT_ID]
```

