<?php

namespace Drupal\custom_module\Controller;

use Symfony\Component\HttpFoundation\JsonResponse;
use Drupal\Core\Controller\ControllerBase;

class JsonController extends ControllerBase {

  public function serveJson(): JsonResponse
  {
    try {
      $path = \Drupal::service('file_system')->realpath(drupal_get_path('module', 'custom_module') . '/data/data.json');
      if (file_exists($path)) {
        $content = file_get_contents($path);
        $jsonContent = json_decode($content, TRUE);

        return new JsonResponse($jsonContent);
      } else {
        return new JsonResponse(['error' => 'File not found'], 404);
      }
    } catch (\Exception $exception) {
      \Drupal::logger('custom_module')->error($exception->getMessage());
      return new JsonResponse(['error' => 'Internal Server Error'], 500);
    }
  }
}
