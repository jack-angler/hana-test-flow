<?php

declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    json_response([
        'success' => false,
        'message' => 'POST method is required.',
    ], 405);
}

try {
    foreach (glob(__DIR__ . '/sql/*.sql') ?: [] as $schemaFile) {
        $schemaSql = file_get_contents($schemaFile);

        if ($schemaSql === false) {
            json_response([
                'success' => false,
                'message' => 'Schema file was not found.',
            ], 500);
        }

        db()->exec($schemaSql);
    }

    json_response([
        'success' => true,
        'message' => 'Database tables were created.',
    ]);
} catch (Throwable $exception) {
    json_response([
        'success' => false,
        'message' => 'Failed to create member tables.',
        'error' => $exception->getMessage(),
    ], 500);
}
