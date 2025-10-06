// whole-backend/routes/webhookRoutes.js
import express from 'express';
const router = express.Router();

/**
 * Handles incoming GitHub POST webhook requests.
 * It's crucial to return a 200 status code quickly for GitHub to consider the delivery successful.
 */
router.post('/github-webhook', (req, res) => {
    console.log('--- GitHub Webhook Received ---');
    console.log('Event Type:', req.headers['x-github-event']);
    console.log('Payload keys:', Object.keys(req.body));
    
    // Add logic here (e.g., start a Jenkins job, process the payload)

    // Respond immediately with a success status
    res.status(200).send('Webhook received successfully.');
});

export default router;
