// whole-backend/routes/webhookRoutes.js

import express from 'express';
const router = express.Router();

/**
 * Fix: Removed regex to prevent server crash (TypeError: Unexpected ()).
 * This route now strictly matches /github-webhook.
 */
router.post('/github-webhook', (req, res) => {
    console.log('--- GitHub Webhook Received ---');
    console.log('Event Type:', req.headers['x-github-event']);
    
    // Respond immediately with a success status
    res.status(200).send('Webhook received successfully.');
});

export default router;